# Dockerfile
 
# استخدام صورة بايثون أساسية
FROM python:3.11-slim
 
# تثبيت التبعيات النظامية اللازمة لتشغيل OpenCV 
# هذه الحزمة (libgl1-mesa-glx) ضرورية لتشغيل الدوال الرسومية لـ OpenCV
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libsm6 \
    libxext6 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*
 
# تعيين دليل العمل
WORKDIR /app
 
# نسخ المتطلبات وتثبيتها أولاً
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
 
# نسخ باقي الكود
COPY . .
 
# أمر التشغيل (الذي يحل محل Procfile)
# نستخدم المنفذ 8000 لأن Docker يقوم بتعيين المنفذ الداخلي (PORT$) يدوياً
CMD ["gunicorn", "main:app", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
