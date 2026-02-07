import http.server
import socketserver
import os

PORT = 5060

class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

# Change directory to build/web
web_dir = os.path.join(os.getcwd(), 'build/web')
if os.path.exists(web_dir):
    os.chdir(web_dir)
    print(f"Serving {web_dir} on port {PORT}")
    with socketserver.TCPServer(('0.0.0.0', PORT), NoCacheHandler) as httpd:
        httpd.serve_forever()
else:
    print(f"Error: Directory {web_dir} does not exist.")
