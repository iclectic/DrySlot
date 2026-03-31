"""Generate branded Dry Slots app icon PNGs using Pillow."""
from PIL import Image, ImageDraw, ImageFont
import os

SIZE = 1024
OUT = os.path.join(os.path.dirname(__file__), '..', 'assets')
os.makedirs(OUT, exist_ok=True)

# App palette colours
INK = (27, 29, 42, 255)
DAWN = (232, 221, 211, 255)
TEAL = (78, 185, 169, 255)
TEAL_DROP = (78, 185, 169, 200)
DAWN_GLOW = (232, 221, 211, 35)

def try_font(size):
    for path in [
        '/System/Library/Fonts/Helvetica.ttc',
        '/System/Library/Fonts/SFNSDisplay.ttf',
    ]:
        try:
            return ImageFont.truetype(path, size)
        except Exception:
            continue
    return ImageFont.load_default()

def draw_cloud(d, ox=0, oy=0, color=DAWN):
    d.ellipse([260+ox, 380+oy, 560+ox, 620+oy], fill=color)
    d.ellipse([420+ox, 320+oy, 720+ox, 580+oy], fill=color)
    d.ellipse([560+ox, 400+oy, 780+ox, 620+oy], fill=color)
    d.rectangle([300+ox, 520+oy, 760+ox, 640+oy], fill=color)

def draw_sun(d, ox=0, oy=0):
    d.ellipse([580+ox, 260+oy, 780+ox, 460+oy], fill=TEAL)

def draw_drops(d, ox=0, oy=0):
    for cx in [380, 500, 620]:
        x, y = cx + ox, 680 + oy
        d.ellipse([x-12, y, x+12, y+40], fill=TEAL_DROP)
        d.polygon([(x-12, y+10), (x, y-30), (x+12, y+10)], fill=TEAL_DROP)

# --- Full icon (with background) ---
img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)
draw.rounded_rectangle([0, 0, SIZE, SIZE], radius=220, fill=INK)
draw.ellipse([180, 180, 844, 844], fill=DAWN_GLOW)
draw_sun(draw)
draw_cloud(draw)          # cloud on top of sun = peeking effect
draw_drops(draw)
font = try_font(120)
draw.text((SIZE // 2, 810), 'DRY', fill=DAWN, font=font, anchor='mm')
img.save(os.path.join(OUT, 'app_icon.png'), 'PNG')

# --- Adaptive foreground (no background) ---
fg = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
fd = ImageDraw.Draw(fg)
draw_sun(fd, oy=-40)
draw_cloud(fd, oy=-40)
draw_drops(fd, oy=-40)
fd.text((SIZE // 2, 770), 'DRY', fill=DAWN, font=font, anchor='mm')
fg.save(os.path.join(OUT, 'app_icon_foreground.png'), 'PNG')

print('Generated assets/app_icon.png and assets/app_icon_foreground.png')
