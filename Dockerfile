# Dockerfile لمشروع Airflow Twitter ETL
FROM apache/airflow:2.7.3-python3.10

# تغيير UID إذا أردت
ARG AIRFLOW_UID=50000
USER root
RUN usermod -u ${AIRFLOW_UID} airflow

# نسخ ملف المتطلبات
COPY requirements.txt /opt/airflow/requirements.txt

# تثبيت الحزم كمستخدم airflow
USER airflow
RUN pip install --no-cache-dir --upgrade pip --verbose && \
    pip install --no-cache-dir -r /opt/airflow/requirements.txt --verbose

# إعداد مجلدات Airflow
USER root
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins \
    && chown -R airflow: /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins

USER airflow
WORKDIR ${AIRFLOW_HOME}

# متغيرات بيئة
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENV AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=True
ENV AIRFLOW__CORE__EXECUTOR=LocalExecutor
ENV AIRFLOW__WEBSERVER__SECRET_KEY=mysecretkey12345
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DEFAULT_TIMEOUT=100

CMD ["bash"]
