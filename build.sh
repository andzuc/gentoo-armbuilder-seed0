#!/bin/bash

tar -C context -cf - .|docker build -t andzuc/gentoo-armbuilder-seed0 -
