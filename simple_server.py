import http.server
import socketserver
import os

PORT = 5060
DIRECTORY = "build/web"

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('X-Frame-Options', 'ALLOWALL')
        self.send_header('Content-Security-Policy', "frame-ancestors *")
        super().end_headers()

if __name__ == "__main__":
    # Ensure we are in the correct directory (project root) or handle relative paths
    if not os.path.exists(DIRECTORY):
        print(f"Error: {DIRECTORY} does not exist.")
        exit(1)
        
    print(f"Starting server on port {PORT} serving {DIRECTORY}...")
    with socketserver.TCPServer(("0.0.0.0", PORT), Handler) as httpd:
        httpd.serve_forever()
