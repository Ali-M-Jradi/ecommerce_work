using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;

namespace EcommerceServer.Controllers
{
    [ApiController]
    [Route("api/item-photo")] // Matches /api/item-photo/{id}
    public class ItemPhotoController : ControllerBase
    {
        private readonly IWebHostEnvironment _environment;
        private readonly ILogger<ItemPhotoController> _logger;

        public ItemPhotoController(IWebHostEnvironment environment, ILogger<ItemPhotoController> logger)
        {
            _environment = environment;
            _logger = logger;
        }

        // GET: /api/item-photo/{id}
        // Looks for a file named {id}.jpg/.jpeg/.png/.webp in common image folders, preferring wwwroot/images/products
        [HttpGet("{id}")]
        public async Task<IActionResult> GetItemPhoto(string id)
        {
            if (string.IsNullOrWhiteSpace(id) || id.Contains("..") || id.Contains('/') || id.Contains('\\'))
            {
                return BadRequest("Invalid id");
            }

            // If id already has an extension, use it; otherwise try common extensions
            var hasExtension = Path.HasExtension(id);
            var candidates = new List<string>();

            string[] roots = new[]
            {
                // Preferred: wwwroot/images/products
                Path.Combine(_environment.WebRootPath ?? _environment.ContentRootPath, "images", "products"),
                Path.Combine(_environment.ContentRootPath, "wwwroot", "images", "products"),
                // Fallbacks: images at various common locations
                Path.Combine(_environment.WebRootPath ?? _environment.ContentRootPath, "images"),
                Path.Combine(_environment.ContentRootPath, "wwwroot", "images"),
                Path.Combine(_environment.ContentRootPath, "Images"),
                Path.Combine(_environment.ContentRootPath, "assets", "images"),
            };

            string[] exts = hasExtension
                ? new[] { string.Empty } // already includes extension
                : new[] { ".jpg", ".jpeg", ".png", ".webp" };

            foreach (var root in roots)
            {
                if (string.IsNullOrWhiteSpace(root)) continue;
                if (!Directory.Exists(root)) continue;

                if (hasExtension)
                {
                    var path = Path.Combine(root, id);
                    candidates.Add(path);
                }
                else
                {
                    foreach (var ext in exts)
                    {
                        candidates.Add(Path.Combine(root, id + ext));
                    }
                }
            }

            string? found = candidates.FirstOrDefault(System.IO.File.Exists);
            if (found == null)
            {
                _logger.LogWarning("Item photo not found for id {Id}", id);
                return NotFound();
            }

            var provider = new FileExtensionContentTypeProvider();
            if (!provider.TryGetContentType(found, out string? contentType))
            {
                contentType = "application/octet-stream";
            }
            // Normalize webp
            if (Path.GetExtension(found).Equals(".webp", StringComparison.OrdinalIgnoreCase))
            {
                contentType = "image/webp";
            }

            var bytes = await System.IO.File.ReadAllBytesAsync(found);
            return File(bytes, contentType);
        }
    }
}
