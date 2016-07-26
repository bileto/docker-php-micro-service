<?php

$default_timezone = date_default_timezone_get();

echo $default_timezone;

$default_timezone === 'UTC' || die(1);
