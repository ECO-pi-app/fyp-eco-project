gunicorn -k uvicorn.workers.UvicornWorker SPHERE.trial:app --bind 0.0.0.0:$PORT
