#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys,time
from rpy2.robjects import r



def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'robo_adviser.settings')

    # print("start load R source", time.time())
    # r("setwd('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0')")
    # r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0/source_server.R', local = TRUE)")
    # print("load R source done", time.time())
    
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
