#!/bin/sh -xe

bundle
rake jenkins || :
