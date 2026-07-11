# Comprehensive Performance, UX, and Endpoint Audit Report

**Date:** July 9, 2026  
**Scope:** Entire Primo Flutter Codebase (`lib/` and `primo.postman_collection.json`)  
**Status:** Audit Complete — Waiting for User Approval before executing fixes.

---

## Executive Summary
This audit investigates the root causes of UI freezing, navigation lag, scrolling stutter, and logical/UX inconsistencies across the application. It also cross-references the backend API specifications (`primo.postman_collection.json`) against existing repository implementations to identify unintegrated endpoints.

---

## Step 1: Performance & Anti-Freeze Audit (CRITICAL)

### 1. JSON Parsing Blocking the Main UI Thread
#### Root Cause Analysis
In Flutter, synchronous decoding and object mapping of large JSON arrays on the UI thread (`Isolate.main`) blocks frame rendering, causing immediate frame drops (jank) and UI freezes.

Currently, all Repositories parse lists synchronously inside `try-catch` blocks:
- **Admin Products (`AdminProductRepoImpl.dart:19`)**:  
  `final products = dataList.map((e) => ProductModel.fromJson(e)).toList();`
- **User Orders (`OrdersRepoImpl.dart:25-28`)**:  
  `(response['data'] as List<dynamic>?)?.map((e) => OrderModel.fromJson(e)).toList()`
- **Admin Categories (`AdminCategoryRepoImpl.dart:41`)**:  
  `dataList.map((e) => CategoryModel.fromJson(e)).toList()`
- **User Products / Catalog (`UserProductsRepoImpl.dart`)**:  
  Synchronous list mapping of products and variants.

#### Proposed Solution
1. Introduce **Background Isolates** via Flutter's `compute()` function for heavy JSON deserialization:
   ```dart
   // Example Proposed Fix
   final products = await compute(parseProductList, response['data']);
   ```
2. Move static top-level parser functions outside repository classes so they can run concurrently in a separate thread without freezing UI animations or navigation transitions.

---

### 2. Image Rendering & Memory Leaks (`Image.network` vs `cached_network_image`)
#### Root Cause Analysis
An audit of `pubspec.yaml` revealed that **`cached_network_image` is not installed**. Consequently, **12 core screen and widget files** rely exclusively on unoptimized `Image.network`:

| File Path | Widget / Component | Issue Description |
| :--- | :--- | :--- |
| `lib/feature/home/presentation/widgets/product_card.dart` | `ProductCard` | Reloads image on scroll; no disk caching |
| `lib/feature/home/presentation/widgets/catigory_chip.dart` | `CategoryChip` | No cache; causes flickering |
| `lib/feature/search/presentation/widgets/user_product_card.dart` | `UserProductCard` | Uncached grid images |
| `lib/feature/categories/presentation/widgets/category_grid_card.dart` | `CategoryGridCard` | Uncached images |
| `lib/feature/favorites/presentation/widgets/favorite_product_card.dart` | `FavoriteProductCard` | Uncached images |
| `lib/feature/cart/presentation/widgets/cart_item_card.dart` | `CartItemCard` | Repeated network calls on cart rebuild |
| `lib/feature/orders/presentation/widgets/order_item_card.dart` | `OrderItemCard` | Uncached order thumbnails |
| `lib/feature/orders/presentation/widgets/order_history_card.dart` | `OrderHistoryCard` | Uncached images |
| `lib/feature/orders/presentation/widgets/order_info.dart` | `OrderInfo` | Uncached images |
| `lib/feature/product/presentation/screen/product_details.dart` | `ProductDetailsScreen` | High-res image loaded without cache |
| `lib/feature/admin_categories/presentation/widgets/category_card.dart` | `CategoryCard` | Uncached admin category icons |
| `lib/feature/admin_offers/presentation/screen/admin_offers_screen.dart` | `AdminOffersScreen` | Uncached promotional banners |

#### Proposed Solution
1. Add `cached_network_image: ^3.4.1` to `pubspec.yaml`.
2. Create a standardized reusable widget (`AppCachedNetworkImage`) with:
   - Shimmer/Loading placeholder
   - Graceful fallback icon on error
   - Automatic memory & disk caching

---

### 3. UI Rebuilds & Scrolling Bottlenecks (`shrinkWrap: true` Abuse)
#### Root Cause Analysis
Across `lib/feature/`, **16 files** use `shrinkWrap: true` inside a `SingleChildScrollView` or nested column:
- `search_results_screen.dart:151`
- `inventory_screen.dart:177`
- `admin_categories_screen.dart:157`
- `admin_offers_screen.dart:151`
- `admin_suggestions_screen.dart:70`
- `direct_orders_screen.dart:96`

Using `shrinkWrap: true` inside a scrolling container **completely disables lazy loading**. Flutter is forced to instantiate, layout, and render every single item in the list immediately upon screen load. When displaying 30+ products or orders, this causes extreme lag and frame drops.

#### Proposed Solution
1. Replace nested `SingleChildScrollView` + `shrinkWrap: true` lists with **`CustomScrollView` and `SliverList` / `SliverGrid`**.
2. Where appropriate, convert standard `ListView` containers to true lazy-loaded `ListView.builder` / `GridView.builder` with proper viewport limits.

---

## Step 2: UX & Logic Polish

### 1. Infinite Loading & Missing Error States
- **Issue**: Several screens render a `CircularProgressIndicator` during loading but lack a retry mechanism if the request fails or times out.
- **Proposed Solution**: Ensure every `BlocBuilder` handles `Loading`, `Error` (with a "Retry" button), and `Empty` states cleanly.

### 2. Immediate Button Feedback & Anti-Double-Tap
- **Issue**: Tapping submit buttons (e.g., adding to cart, confirming orders, saving admin settings) can allow duplicate clicks if the user taps rapidly before the state transitions to loading.
- **Proposed Solution**: Automatically disable action buttons when the Cubit state is `Loading` and display an inline loader inside the button.

### 3. Navigation Transition Optimization
- **Issue**: Mixing heavy synchronous operations inside `initState` during route transitions causes page transition stutter.
- **Proposed Solution**: Ensure data fetching in `initState` occurs after the route animation finishes (`WidgetsBinding.instance.addPostFrameCallback`), which is already partially adopted and will be standardized across all remaining screens.

---

## Step 3: Unused Endpoints Scan

Cross-referencing `primo.postman_collection.json` and `ApiConstant` with the existing Dart repositories revealed the following unintegrated or pending endpoints:

### 1. User Order / Product Rating (`POST /user/products/:product_id/rate/ordar/:ordar_id`)
- **Status**: Defined in Postman collection (line 7281) and present in `OrdersRepoImpl.dart:105`, but **unused in the User UI**.
- **Proposed Implementation**: Add a "Rate Product / Order" interactive modal or button in `OrderDetailsScreen` and `OrderHistoryCard` once an order status reaches `"completed"`.

### 2. Admin Variant Deletion (`DELETE /admin/variants/:variant/delete`)
- **Status**: Defined in `ApiConstant.adminVariants` and implemented in `AdminProductRepo.deleteVariant`, but **never triggered from the UI** when an admin deletes an existing variant inside `EditProductScreen`.
- **Proposed Implementation**: Connect the variant removal button in `EditProductScreen` to trigger `deleteVariant(id)` when modifying existing variants.

### 3. Admin Orders Management (`GET /admin/ordars`, `GET /admin/ordars/:id`, `POST /admin/ordars/status/:id`)
- **Status**: Currently represented by 0-byte placeholder files (`admin_orders_repo_impl.dart`, `admin_orders_cubit.dart`).
- **Proposed Implementation**: This represents **Module 7 (Admin Orders Management)**. Full Clean Architecture implementation will cover list filtering, single order inspection, and status updates (`pending`, `processing`, `completed`, `cancelled`).

---

## Next Action Required
No code changes have been applied yet. Please review this audit report. Upon your approval, we will execute the performance optimizations (Isolate JSON parsing, `cached_network_image` migration, `SliverList` lazy scrolling fixes) and UX polish systematically.
