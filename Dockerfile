FROM jupyter/all-spark-notebook:latest

RUN pip install pandas matplotlib
RUN pip install jupyter-cpp-kernel


#psycopg2-binary bash_kernel

