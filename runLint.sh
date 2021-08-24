#!/bin/sh
# Convenience script for running the ansible-lint command

ansible-test sanity --docker -v --color --python 3.6
