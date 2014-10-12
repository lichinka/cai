#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage:"
    echo "$0 [column (eastern) cell coordinate] [row (northern) cell coordinate]"
    echo "Returns coverage (gamme) value at given coordinates."
else
    ESTE=$(($1*100+319950))
    NORTE=$(($2*-100+224050))
    r.what --v -f input=coverage_final@ijs_01 east_north=${ESTE},${NORTE}
fi

