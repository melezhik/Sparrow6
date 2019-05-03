unit module Sparrow6::Task::Runner::Helpers::Test;

role Role {

  method stdout-ok ($re) {

    for self.stdout-data -> $line {
      if $line ~~ /$re/ {
        self!test-log("pass test", "stdout match <$re>") if $.show-test-result;
        return True
      }
    }

    self!test-log("fail test","stdout ~~ $re");
    $.test-pass = False;
  
  }

}

