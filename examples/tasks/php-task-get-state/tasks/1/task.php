<?php
$s = get_state();
if ($s["message"] == "hello from task2"){
  print("state.message == hello from task2\n");
}
print("{$s['message']}\n");
?>
