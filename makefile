all: linux windows web
linux:
	godot4-beta4 --path gdproj/ --export "Linux/X11" --headless
	upx export/linux/twolefthands.x86_64
windows:
	godot4-beta4 --path gdproj/ --export "Windows Desktop" --headless
	upx export/windows/twolefthands.exe
web:
	godot4-beta4 --path gdproj/ --export "Web" --headless
