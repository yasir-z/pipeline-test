# Python ka minimal slim image use kar rahe hain
FROM python:3.12-slim

# System packages ko update aur patch karein taake known CVEs remove ho jayein
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/

# Working directory set karein
WORKDIR /app

# Requirements file copy kar ke dependencies install karein
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Application code copy karein
COPY app/ app/

# Port expose karein
EXPOSE 5000

# Application run karne ki command
CMD ["python", "app/app.py"]
