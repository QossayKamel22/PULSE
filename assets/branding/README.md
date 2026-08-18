# Branding assets

Place the official PULSE logo files here:

- `pulse_logo.png` — primary mark
- `pulse_logo_light.png` — variant for dark backgrounds
- `pulse_logo_dark.png` — variant for light backgrounds

Until real files are added, `lib/core/widgets/pulse_logo.dart` renders a
code-drawn placeholder (gradient circle + pulse-wave glyph) so the app
still looks intentional. Once the real assets are here, swap that widget's
body for an `Image.asset('assets/branding/pulse_logo.png')` and update the
app icon / splash screen configuration accordingly.
