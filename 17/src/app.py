"""A small web service that starts background jobs and shuts down gracefully."""
import signal
import subprocess
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.reply("OK\n")
        elif self.path == "/report":
            # Start a report in the background. The shell exits right away and
            # leaves the job running on its own, as many tools do.
            subprocess.run(["sh", "-c", "sleep 1 &"], check=True)
            self.reply("Report started\n")
        else:
            self.reply("Hello from a well-behaved container\n")

    def reply(self, body):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(body.encode())


def shutdown(signum, frame):
    # In a real service: stop accepting requests, finish the ongoing ones,
    # close database connections and flush buffers
    print(f"Received {signal.Signals(signum).name}, shutting down gracefully")
    sys.exit(0)


signal.signal(signal.SIGTERM, shutdown)
print("Listening on port 8000")
HTTPServer(("", 8000), Handler).serve_forever()
