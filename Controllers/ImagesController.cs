using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using System.IO;

namespace EcommerceServer.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ImagesController : ControllerBase
    {
        private readonly IWebHostEnvironment _environment;
        private readonly ILogger<ImagesController> _logger;

        public ImagesController(IWebHostEnvironment environment, ILogger<ImagesController> logger)
        {
            _environment = environment;
            _logger = logger;
        }

        [HttpGet("{filename}")]
        public async Task<IActionResult> GetImage(string filename)
        {
            try
            {
                // Validate filename to prevent path traversal attacks
                if (string.IsNullOrEmpty(filename) || filename.Contains("..") || filename.Contains("/") || filename.Contains("\\"))
                {
                    _logger.LogWarning($"Invalid filename requested: {filename}");
                    return BadRequest("Invalid filename");
                }

                // Define possible image directories
                var imagePaths = new[]
                {
                    Path.Combine(_environment.WebRootPath, "images", filename),
                    Path.Combine(_environment.ContentRootPath, "wwwroot", "images", filename),
                    Path.Combine(_environment.ContentRootPath, "Images", filename),
                    Path.Combine(_environment.ContentRootPath, "assets", "images", filename),
                    // Add your specific image directory paths here
                    Path.Combine("C:\\", "FlutterProjects", "ecommerce_work", "ecommerce", "assets", "images", filename)
                };

                string? foundImagePath = null;
                foreach (var imagePath in imagePaths)
                {
                    if (System.IO.File.Exists(imagePath))
                    {
                        foundImagePath = imagePath;
                        break;
                    }
                }

                if (foundImagePath == null)
                {
                    _logger.LogWarning($"Image not found: {filename}");
                    return NotFound($"Image '{filename}' not found");
                }

                // Get content type based on file extension
                var provider = new FileExtensionContentTypeProvider();
                if (!provider.TryGetContentType(foundImagePath, out string? contentType))
                {
                    // Default content type for unknown extensions
                    contentType = "application/octet-stream";
                }

                // Special handling for WebP images
                if (Path.GetExtension(foundImagePath).ToLowerInvariant() == ".webp")
                {
                    contentType = "image/webp";
                }

                _logger.LogInformation($"Serving image: {filename} from {foundImagePath}");

                // Read and return the image file
                var imageBytes = await System.IO.File.ReadAllBytesAsync(foundImagePath);
                return File(imageBytes, contentType);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error serving image: {filename}");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpGet]
        public IActionResult GetImagesList()
        {
            try
            {
                var imagePaths = new[]
                {
                    Path.Combine(_environment.WebRootPath, "images"),
                    Path.Combine(_environment.ContentRootPath, "wwwroot", "images"),
                    Path.Combine(_environment.ContentRootPath, "Images"),
                    Path.Combine(_environment.ContentRootPath, "assets", "images"),
                    Path.Combine("C:\\", "FlutterProjects", "ecommerce_work", "ecommerce", "assets", "images")
                };

                var imageFiles = new List<string>();
                
                foreach (var imagePath in imagePaths)
                {
                    if (Directory.Exists(imagePath))
                    {
                        var files = Directory.GetFiles(imagePath, "*.*", SearchOption.TopDirectoryOnly)
                            .Where(file => IsImageFile(file))
                            .Select(Path.GetFileName)
                            .Where(name => !string.IsNullOrEmpty(name));
                        
                        imageFiles.AddRange(files!);
                    }
                }

                return Ok(new { images = imageFiles.Distinct().ToArray() });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting images list");
                return StatusCode(500, "Internal server error");
            }
        }

        private static bool IsImageFile(string filename)
        {
            var extension = Path.GetExtension(filename).ToLowerInvariant();
            return extension == ".jpg" || extension == ".jpeg" || 
                   extension == ".png" || extension == ".gif" || 
                   extension == ".webp" || extension == ".bmp" || 
                   extension == ".svg" || extension == ".avif";
        }
    }
}
