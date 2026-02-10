<?php
print("hello world\n");
$c = config();
if ($c["hello"] == "php"){
  print("hello param == php\n");
}
print("{$c['hello']}\n");
?>
