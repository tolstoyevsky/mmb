<?php

/*
 * This simple script is used for checking that the development environment
 * works correctly.
 */

$info = $_GET['info'];
if (isset($info)) {
    if ($info == 'php') {
        phpinfo();
    } else {
        xdebug_info();
    }
} else {
    echo "The environment works!";
}

?>
