#use warnings;

open(FH, "$ARGV[0]");
$i = 0;
# ラベル、カンマ、空白、タブの処理
while($line = <FH>){
$line =~ s/,/ /g;
$line =~ s/\t/ /g;
$line =~ s/\:/ : /g;
$line =~ s/^ +//g;
chomp($line);
$instruction = split(/ +/, $line);
if ($instruction[1] eq ":") {$labels{$instruction[0]} = $i;
}
$i++;
}
close(FH);

open(FH, "$ARGV[0]");
$i = 0;
while($line = <FH>){
  $line =~ s/,/ /g;
  $line =~ s/\t / /g;
  $line =~ s/\:/ : /g;
  $line =~ s/^ +//g;
  chomp($line);
  @instruction= split(/ +/, $line);
  if ($instruction[1] eq ":"){
    $op = $instruction[2];
    $f2 = $instruction[3];
    $f3 = $instruction[4];
    $f4 = $instruction[5];
    $f5 = $instruction[6];
  }
  else{
    $op = $instruction[0];
    $f2 = $instruction[1];
    $f3 = $instruction[2];
    $f4 = $instruction[3];
    $f5 = $instruction[4];
  }


#機械語の出力
if ($op eq "add"){p_b(6,0); p_r3($f2, $f3, $f4); p_b(11,0);print("\n");}
elsif ($op eq "addi") {p_b(6,1); p_r2i($f2, $f3); p_b(16, $f4);print("\n");}
elsif ($op eq "sub"){p_b(6,0); p_r3($f2, $f3, $f4); p_b(11, 2); print("\n");}
elsif ($op eq "lui") {p_b(6,3); p_r2i($f2, "r0"); p_b(16, $f3);print("\n");}
elsif ($op eq "and"){p_b(6,0); p_r3($f2, $f3, $f4); p_b(11, 8); print("\n");}
elsif ($op eq "andi") {p_b(6,4); p_r2i($f2, $f3); p_b(16, $f4);print("\n");}
elsif ($op eq "or"){p_b(6,0); p_r3($f2, $f3, $f4); p_b(11,9);print("\n");}
elsif ($op eq "ori"){p_b(6,5); p_r2i($f2, $f3); p_b(16, $f4);print("\n");}
elsif ($op eq "xor"){p_b(6,0); p_r3($f2, $f3, $f4); p_b(11,10);print("\n");}
elsif ($op eq "xori"){p_b(6,6); p_r2i($f2, $f3); p_b(16, $f4);print("\n");}
elsif ($op eq "nor"){p_b(6,0); p_r3($f2, $f3, $f4); p_b(11,11);print("\n");}
elsif ($op eq "sll"){p_b(6,0); p_r3($f2, $f3, "r0"); p_b(5, $f4); p_b(6,16);print("\n");}
elsif ($op eq "srl"){p_b(6,0); p_r3($f2, $f3, "r0"); p_b(5, $f4); p_b(6,17);print("\n");}
elsif ($op eq "sra"){p_b(6,0); p_r3($f2, $f3, "r0"); p_b(5, $f4); p_b(6,18);print("\n");}
elsif ($op eq "lw"){p_b(6,16); p_r2i($f2, base($f3)); p_b(16, dpl($f3));print("\n");}
elsif ($op eq "lh"){p_b(6,18); p_r2i($f2, base($f3)); p_b(16, dpl($f3));print("\n");}
elsif ($op eq "lb"){p_b(6,20); p_r2i($f2, base($f3)); p_b(16, dpl($f3));print("\n");}
elsif ($op eq "sw"){p_b(6,24); p_r2i($f2, base($f3)); p_b(16, dpl($f3));print("\n");}
elsif ($op eq "sh"){p_b(6,26); p_r2i($f2, base($f3)); p_b(16, dpl($f3));print("\n");}
elsif ($op eq "sb"){p_b(6,28); p_r2i($f2, base($f3)); p_b(16, dpl($f3));print("\n");}
elsif ($op eq "beq") {p_b(6,32); p_r2b($f2, $f3); p_b(16, $labels{$f4}-$i-1);print("\n");}
elsif ($op eq "bne") {p_b(6,33); p_r2b($f2, $f3); p_b(16, $labels{$f4}-$i-1);print("\n");}
elsif ($op eq "blt") {p_b(6,34); p_r2b($f2, $f3); p_b(16, $labels{$f4}-$i-1);print("\n");}
elsif ($op eq "ble") {p_b(6,35); p_r2b($f2, $f3); p_b(16, $labels{$f4}-$i-1);print("\n");}
elsif ($op eq "j") {p_b(6,40); p_b(26, $labels{$f2});print("\n");}
elsif ($op eq "jal"){p_b(6, 41); p_b(26, $labels{$f2});print("\n");}
elsif ($op eq "jr"){p_b(6, 42); p_r3("r0", $f2, "r0"); p_b(11, 0);print("\n");}
else {print("ERROR: Illegal Instruction\n");}
$i++;
}
close(FH);

sub p_b{
  ($digits,$num) = @_;
  if($num >= 0){
    printf("%0".$digits."b_", $num);
  }
  else{
    print(substr(sprintf("%b ", $num), 64-$digits));
  }
}

sub p_r3{# R型のレジスタ番地を出力
($rd, $rs, $rt) = @_;
$rs =~ s/r//; p_b(5, $rs);
$rt =~ s/r//; p_b(5, $rt);
$rd =~ s/r//; p_b(5, $rd);
}

sub p_r2i{# I型のレジスタ番地を出力
($rt, $rs) = @_;
$rs =~ s/r//; p_b(5, $rs);
$rt =~ s/r//; p_b(5, $rt);
}

sub p_r2b{#条件分岐で比較するレジスタ番地を出力
($rs, $rt) = @_;
$rs =~ s/r//; p_b(5, $rs);
$rt =~ s/r//; p_b(5, $rt);
}

sub base{# ベースアドレスレジスタの番地を返す
($addr) = @_;
$addr =~ s/.*\(//;
$addr =~ s/\)//;
return($addr);
}

sub dpl{#変位を返す
($addr) = @_;
$addr =~ s/\(.*\)//;
return($addr);
}
