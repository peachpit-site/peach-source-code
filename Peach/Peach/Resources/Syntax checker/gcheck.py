import ast
import io
import os
import sys

current_directory = os.getcwd()

with io.open(current_directory+'\\Resources\\File transfer\\patogc.rsc', "r", encoding="utf-8") as file:
    data_in = file.readlines()
filename = (data_in[0].rstrip())

error_report = ""
error_line = -1

with io.open(current_directory+'\\Resources\\Py files\\'+filename+'.py', "r", encoding="utf-8") as f:
    source = f.read()
try:
    ast.parse(source)
except SyntaxError as err:
    error_report = str(err)
    error_line = err.lineno
finally:
    with io.open(current_directory+'\\Resources\\File transfer\\gctopa.rsc', "w", encoding="utf-8") as file:
        file.write(error_report+"\n")
        file.write(str(error_line)+"\n")
