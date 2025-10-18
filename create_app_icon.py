#!/usr/bin/env python3
"""
Script to create app icon PNG from the USSD+ logo design
This creates a high-quality PNG version of the logo for use as app icon
"""

from PIL import Image, ImageDraw, ImageFont
import math

def create_app_icon(size=1024):
    """Create app icon with the USSD+ logo design"""
    
    # Create image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Calculate dimensions
    center = size // 2
    radius = size // 3
    
    # Create gradient background (simplified - using solid color for now)
    # Primary gradient: Indigo to Purple
    bg_color = (99, 102, 241, 255)  # #6366F1 (Indigo)
    
    # Draw main circle background
    draw.ellipse(
        [center - radius, center - radius, center + radius, center + radius],
        fill=bg_color,
        outline=(139, 92, 246, 255)  # #8B5CF6 (Purple) outline
    )
    
    # Draw plus badge (top right)
    plus_size = size // 8
    plus_x = center + radius - plus_size
    plus_y = center - radius + plus_size
    
    # Plus badge background
    draw.ellipse(
        [plus_x - plus_size//2, plus_y - plus_size//2, 
         plus_x + plus_size//2, plus_y + plus_size//2],
        fill=(16, 185, 129, 255),  # #10B981 (Green)
        outline=(59, 130, 246, 255)  # #3B82F6 (Blue) outline
    )
    
    # Draw plus sign
    plus_thickness = plus_size // 6
    # Horizontal line
    draw.rectangle(
        [plus_x - plus_size//3, plus_y - plus_thickness//2,
         plus_x + plus_size//3, plus_y + plus_thickness//2],
        fill=(255, 255, 255, 255)
    )
    # Vertical line
    draw.rectangle(
        [plus_x - plus_thickness//2, plus_y - plus_size//3,
         plus_x + plus_thickness//2, plus_y + plus_size//3],
        fill=(255, 255, 255, 255)
    )
    
    # Draw main dialpad icon
    dialpad_size = size // 4
    dialpad_x = center
    dialpad_y = center
    
    # Draw dialpad grid (3x4 grid)
    grid_width = dialpad_size // 3
    grid_height = dialpad_size // 4
    
    # Draw grid lines
    for i in range(4):  # Horizontal lines
        y = dialpad_y - dialpad_size//2 + i * grid_height
        draw.line(
            [dialpad_x - dialpad_size//2, y, dialpad_x + dialpad_size//2, y],
            fill=(255, 255, 255, 255),
            width=max(2, size//200)
        )
    
    for i in range(4):  # Vertical lines
        x = dialpad_x - dialpad_size//2 + i * grid_width
        draw.line(
            [x, dialpad_y - dialpad_size//2, x, dialpad_y + dialpad_size//2],
            fill=(255, 255, 255, 255),
            width=max(2, size//200)
        )
    
    # Draw * and # symbols
    symbol_size = grid_width // 3
    
    # * symbol (top-left)
    star_x = dialpad_x - dialpad_size//2 + grid_width//2
    star_y = dialpad_y - dialpad_size//2 + grid_height//2
    draw.text(
        (star_x - symbol_size//2, star_y - symbol_size//2),
        '*',
        fill=(255, 255, 255, 255),
        font=ImageFont.load_default()
    )
    
    # # symbol (bottom-right)
    hash_x = dialpad_x + dialpad_size//2 - grid_width//2
    hash_y = dialpad_y + dialpad_size//2 - grid_height//2
    draw.text(
        (hash_x - symbol_size//2, hash_y - symbol_size//2),
        '#',
        fill=(255, 255, 255, 255),
        font=ImageFont.load_default()
    )
    
    # Add some decorative circles
    for i in range(3):
        circle_radius = size // 20
        angle = i * 2 * math.pi / 3
        circle_x = center + int((radius + size//8) * math.cos(angle))
        circle_y = center + int((radius + size//8) * math.sin(angle))
        
        draw.ellipse(
            [circle_x - circle_radius, circle_y - circle_radius,
             circle_x + circle_radius, circle_y + circle_radius],
            fill=(255, 255, 255, 50),  # Semi-transparent white
            outline=(255, 255, 255, 100)
        )
    
    return img

def main():
    """Generate app icon in multiple sizes"""
    
    # Create assets/icons directory if it doesn't exist
    import os
    os.makedirs('assets/icons', exist_ok=True)
    
    # Generate different sizes
    sizes = [1024, 512, 256, 128, 64]
    
    for size in sizes:
        print(f"Generating {size}x{size} icon...")
        icon = create_app_icon(size)
        icon.save(f'assets/icons/app_icon_{size}.png')
    
    # Also create the main app_icon.png (1024x1024)
    main_icon = create_app_icon(1024)
    main_icon.save('assets/icons/app_icon.png')
    
    print("✅ App icons generated successfully!")
    print("📁 Icons saved to assets/icons/")
    print("🎨 Main icon: app_icon.png (1024x1024)")
    print("📱 Various sizes: app_icon_512.png, app_icon_256.png, etc.")

if __name__ == "__main__":
    main()
