using Microsoft.AspNetCore.Mvc;

namespace EcommerceServer.Controllers
{
    [ApiController]
    [Route("api/site-images")]
    public class SiteImagesController : ControllerBase
    {
        private readonly IWebHostEnvironment _environment;
        private readonly ILogger<SiteImagesController> _logger;

        public SiteImagesController(IWebHostEnvironment environment, ILogger<SiteImagesController> logger)
        {
            _environment = environment;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult GetSiteImages()
        {
            try
            {
                // Define the carousel images that should be returned
                var carouselImages = new[]
                {
                    "digital-art-style-mental-health-day-awareness-illustration.png",
                    "gift_icon.jpg",
                    "three_leaves.png",
                    "whatsapp_icon.jpg"
                };

                // Define possible image directories to check if images exist
                var imagePaths = new[]
                {
                    Path.Combine(_environment.WebRootPath, "images"),
                    Path.Combine(_environment.ContentRootPath, "wwwroot", "images"),
                    Path.Combine(_environment.ContentRootPath, "Images"),
                    Path.Combine(_environment.ContentRootPath, "assets", "images"),
                    Path.Combine("C:\\", "FlutterProjects", "ecommerce_work", "ecommerce", "assets", "images")
                };

                var availableImages = new List<string>();

                foreach (var imageName in carouselImages)
                {
                    // Check if image exists in any of the directories
                    bool imageExists = false;
                    foreach (var directory in imagePaths)
                    {
                        if (Directory.Exists(directory))
                        {
                            var imagePath = Path.Combine(directory, imageName);
                            if (System.IO.File.Exists(imagePath))
                            {
                                imageExists = true;
                                break;
                            }
                        }
                    }

                    if (imageExists)
                    {
                        // Return the URL that the mobile app can use to fetch the image
                        // This assumes your server is running and accessible
                        availableImages.Add($"http://192.168.100.54:89/api/images/{imageName}");
                    }
                    else
                    {
                        _logger.LogWarning($"Carousel image not found: {imageName}");
                    }
                }

                var response = new
                {
                    success = true,
                    message = "Site images retrieved successfully",
                    data = availableImages,
                    count = availableImages.Count,
                    timestamp = DateTime.UtcNow
                };

                _logger.LogInformation($"Returning {availableImages.Count} carousel images");
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting site images");
                return StatusCode(500, new 
                { 
                    success = false, 
                    message = "Internal server error", 
                    error = ex.Message 
                });
            }
        }

        [HttpGet("test")]
        public IActionResult TestEndpoint()
        {
            return Ok(new 
            { 
                success = true, 
                message = "Site Images API is working!", 
                timestamp = DateTime.UtcNow,
                serverInfo = new
                {
                    environment = _environment.EnvironmentName,
                    contentRootPath = _environment.ContentRootPath,
                    webRootPath = _environment.WebRootPath
                }
            });
        }
    }
}
