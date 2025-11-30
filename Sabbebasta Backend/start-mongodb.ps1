# MongoDB Startup Script
# Run this as Administrator

Write-Host "=== Starting MongoDB Service ===" -ForegroundColor Cyan

try {
    $service = Get-Service -Name "MongoDB" -ErrorAction Stop
    
    if ($service.Status -eq 'Running') {
        Write-Host "✓ MongoDB is already running" -ForegroundColor Green
    } else {
        Start-Service -Name "MongoDB" -ErrorAction Stop
        Write-Host "✓ MongoDB service started successfully" -ForegroundColor Green
        Start-Sleep -Seconds 2
        
        # Verify it's running
        $service = Get-Service -Name "MongoDB"
        if ($service.Status -eq 'Running') {
            Write-Host "✓ MongoDB is now running on port 27017" -ForegroundColor Green
        } else {
            Write-Host "✗ MongoDB service failed to start" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nMake sure:" -ForegroundColor Yellow
    Write-Host "1. You're running PowerShell as Administrator" -ForegroundColor White
    Write-Host "2. MongoDB is installed on your system" -ForegroundColor White
    Write-Host "3. MongoDB service exists (check Services.msc)" -ForegroundColor White
}

