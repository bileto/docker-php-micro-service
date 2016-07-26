<?php

exec('composer --version 2>&1', $output, $retval);

echo implode(PHP_EOL, $output).PHP_EOL;

$retval === 0 || die(1);
