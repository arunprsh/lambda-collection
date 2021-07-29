ARG FUNCTION_DIR="/function"

FROM python:3.7-slim

# Install FreeTDS and dependencies
RUN apt-get update \
 && apt-get install unixodbc -y \
 && apt-get install unixodbc-dev -y \
 && apt-get install freetds-dev -y \
 && apt-get install freetds-bin -y \
 && apt-get install tdsodbc -y \
 && apt-get install --reinstall build-essential -y

# Populate ocbcinst.ini
RUN echo "[FreeTDS]\n\
Description = FreeTDS unixODBC Driver\n\
Driver = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so\n\
Setup = /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" >> /etc/odbcinst.ini

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy function code
COPY app/* ${FUNCTION_DIR}/

COPY requirements.txt ${FUNCTION_DIR}/
RUN python3 -m pip install --no-cache-dir -r ${FUNCTION_DIR}/requirements.txt

# Install the runtime interface client
RUN python3 -m pip install awslambdaric

ENTRYPOINT [ "/usr/local/bin/python3", "-m", "awslambdaric" ]

# Set the CMD to your handler
CMD [ "app.handler" ]