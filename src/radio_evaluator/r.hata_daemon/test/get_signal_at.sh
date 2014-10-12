 #!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage:"
    echo "$0 [transmitter ID][eastern cell coordinate] [northern cell coordinate]"
    echo "Returns path-loss value of transmitter at given coordinates."
else
    ESTE=$(($2*100+319950))
    NORTE=$(($3*-100+224050))
    r.what --v -f input=qrm_154_$1@ijs_01 east_north=${ESTE},${NORTE}
fi

