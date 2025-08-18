// Correct API-driven approach for your image controller
// This fetches images from your database/content system, not local files

using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/images")]
public class ImagesController : ControllerBase
{
    private readonly IContentService _contentService; // Your existing content service

    public ImagesController(IContentService contentService)
    {
        _contentService = contentService;
    }

    [HttpGet("{filename}")]
    public async Task<IActionResult> GetImage(string filename)
    {
        try
        {
            // Get image data from your database/content management system
            // This could be:
            // 1. Binary data stored in database
            // 2. URL to cloud storage (redirect)
            // 3. Base64 data converted to bytes
            // 4. File path from content management records
            
            var imageData = await _contentService.GetImageByFilenameAsync(filename);
            
            if (imageData == null || imageData.Length == 0)
            {
                return NotFound($"Image {filename} not found in content system");
            }

            // Set proper content type based on file extension
            var contentType = GetContentTypeFromFilename(filename);
            
            return File(imageData, contentType);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error retrieving image: {ex.Message}");
        }
    }

    [HttpGet("health")]
    public IActionResult Health()
    {
        return Ok(new { 
            status = "healthy", 
            message = "Image API is ready to serve content-managed images" 
        });
    }

    private string GetContentTypeFromFilename(string filename)
    {
        var extension = Path.GetExtension(filename).ToLowerInvariant();
        return extension switch
        {
            ".webp" => "image/webp",
            ".jpg" or ".jpeg" => "image/jpeg",
            ".png" => "image/png",
            ".gif" => "image/gif",
            _ => "application/octet-stream"
        };
    }
}

// You'll need to add this method to your existing content service:
public interface IContentService 
{
    Task<byte[]?> GetImageByFilenameAsync(string filename);
    // ... your existing methods
}

public class ContentService : IContentService
{
    // Method to get image binary data by filename
    public async Task<byte[]?> GetImageByFilenameAsync(string filename)
    {
        // Implementation depends on how you store images:
        
        // Option 1: Images stored as BLOB in database
        // return await _dbContext.Images
        //     .Where(i => i.Filename == filename)
        //     .Select(i => i.ImageData)
        //     .FirstOrDefaultAsync();
        
        // Option 2: Images stored in cloud (Azure, AWS, etc.)
        // var imageUrl = await GetImageUrlFromDatabase(filename);
        // return await DownloadImageFromCloud(imageUrl);
        
        // Option 3: Images managed through CMS
        // return await _cmsService.GetImageDataAsync(filename);
        
        throw new NotImplementedException("Implement based on your image storage strategy");
    }
}
