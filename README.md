## Product images for /api/item-photo/{id}

The mobile app loads product photos from `/api/item-photo/{id}`. To make this work:

- Place images under `wwwroot/images/products` on the C# server project.
- Name each image by product id (with supported extensions):
	- Example: `wwwroot/images/products/123.jpg` or `123.png` or `123.webp`.
- The endpoint will try `.jpg`, `.jpeg`, `.png`, `.webp` if you don’t include an extension.

If you prefer a different storage path, update `ItemPhotoController` roots accordingly.

# ecommerce_work
ecommerce cosmetics mobile app for work
