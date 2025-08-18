using Microsoft.AspNetCore.Mvc;

namespace EcommerceServer.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SimpleImagesController : ControllerBase
    {
        private readonly ILogger<SimpleImagesController> _logger;
        private readonly string _imagesPath;

        public SimpleImagesController(ILogger<SimpleImagesController> logger)
        {
            _logger = logger;
            // Point directly to your Flutter assets/images folder
            _imagesPath = @"C:\FlutterProjects\ecommerce_work\ecommerce\assets\images";
        }

        [HttpGet("{filename}")]
        public async Task<IActionResult> GetImage(string filename)
        {
            try
            {
                // Security check
                if (string.IsNullOrEmpty(filename) || filename.Contains(".."))
                {
                    return BadRequest("Invalid filename");
                }

                var filePath = Path.Combine(_imagesPath, filename);
                
                if (!System.IO.File.Exists(filePath))
                {
                    _logger.LogWarning($"Image not found: {filename} at {filePath}");
                    return NotFound($"Image '{filename}' not found");
                }

                var fileBytes = await System.IO.File.ReadAllBytesAsync(filePath);
                
                // Determine content type
                var contentType = filename.ToLowerInvariant() switch
                {
                    var f when f.EndsWith(".webp") => "image/webp",
                    var f when f.EndsWith(".jpg") || f.EndsWith(".jpeg") => "image/jpeg",
                    var f when f.EndsWith(".png") => "image/png",
                    var f when f.EndsWith(".gif") => "image/gif",
                    var f when f.EndsWith(".svg") => "image/svg+xml",
                    _ => "application/octet-stream"
                };

                _logger.LogInformation($"✅ Serving image: {filename} ({fileBytes.Length} bytes)");
                return File(fileBytes, contentType);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"❌ Error serving image: {filename}");
                return StatusCode(500, "Error loading image");
            }
        }
    }
}
