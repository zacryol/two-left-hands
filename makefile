all: linux windows web
linux:
	godot4-beta5 --path gdproj/ --export-release "Linux/X11" --headless
	upx export/linux/twolefthands.x86_64
windows:
	godot4-beta5 --path gdproj/ --export-release "Windows Desktop" --headless
	upx export/windows/twolefthands.exe
web:
	godot4-beta5 --path gdproj/ --export-release "Web" --headless
