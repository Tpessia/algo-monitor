FROM nikolaik/python-nodejs:python3.7-nodejs12
COPY backend/ /app/backend
COPY frontend/ /app/frontend
WORKDIR /app
RUN pip install gunicorn
RUN pip install -r backend/requirements.txt
RUN cd frontend && npm install && npm run build && cd ..
CMD cd backend && gunicorn server:app -b 0.0.0.0:80 --workers=1 --threads=3 > status.log 2>&1
EXPOSE 80