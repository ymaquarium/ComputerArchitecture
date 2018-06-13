use strict;
use warnings;
#use Module::Requires

#1
open(FH, "$ARGV[0]");
my $i = 0;
# ラベル、カンマ、空白、タブの処理
while (my $line = <FH>) {
$line =~ s/,/ /g;
$line =~ s/¥t/ /g;
$line =~ s/¥:/ : /g;
$line =~ s/^ +//g;
chomp(my $line);
my @instruction = split(/ +/, $line);
if ($instruction[1] eq ":") {
my $labels{$instruction[0]} = $i;
}
$i++;
}


close(FH);

#2
open(FH, "$ARGV[0]");
$i = 0;
while (my $line = <FH>) {
# print("$i : ");
$line =~ s/,/ /g;
$line =~ s/¥t+/ /g;
$line =~ s/¥:/ : /g;
$line =~ s/^ +//g;
# print($line);
chomp($line);
my @instruction = split(/ +/, $line);
if ($instruction[1] eq ":") {# ラベルのある行をフィールドに分割する
my $op = $instruction[2];
my $f2 = $instruction[3];
my $f3 = $instruction[4];
my $f4 = $instruction[5];
my $f5 = $instruction[6];
}
else {# ラベルのない行をフィールド分割する
my $op = $instruction[0];
my $f2 = $instruction[1];
my $f3 = $instruction[2];
my $f4 = $instruction[3];
my $f5 = $instruction[4];
}
# 機械語の出力
if (my $op eq "add"){p_b(6,0); p_r3(my $f2, my $f3, my $f4); p_b(11,0);print("¥n");}
elsif ($op eq "addi") {p_b(6,1); p_r2i(my $f2, my $f3); p_b(16, my $f4);print("¥n");}
elsif ($op eq "sub"){p_b(6,0); p_r3(my $f2, my $f3, my $f4); p_b(11, 2); print("¥n");}
elsif ($op eq "lui") {p_b(6,3); p_r2i(my $f2, "r0"); p_b(16, my $f3);print("¥n");}
elsif ($op eq "and"){p_b(6,0); p_r3(my $f2, my $f3, my $f4); p_b(11, 8); print("¥n");}
elsif ($op eq "andi") {p_b(6,4); p_r2i(my $f2, my $f3); p_b(16, my $f4);print("¥n");}
elsif ($op eq "or"){p_b(6,0); p_r3(my $f2, my $f3, my $f4); p_b(11,9);print("¥n");}
elsif ($op eq "ori"){p_b(6,5); p_r2i(my $f2, my $f3); p_b(16, my $f4);print("¥n");}
elsif ($op eq "xor"){p_b(6,0); p_r3(my $f2, my $f3, my $f4); p_b(11,10);print("¥n");}
elsif ($op eq "xori"){p_b(6,6); p_r2i(my $f2, my $f3); p_b(16, my $f4);print("¥n");}
elsif ($op eq "nor"){p_b(6,0); p_r3(my $f2, my $f3, my $f4); p_b(11,11);print("¥n");}
elsif ($op eq "sll"){p_b(6,0); p_r3(my $f2, my $f3, "r0"); p_b(5, my $f4); p_b(6,16);print("¥n");}
elsif ($op eq "srl"){p_b(6,0); p_r3(my $f2, my $f3, "r0"); p_b(5, my $f4); p_b(6,17);print("¥n");}
elsif ($op eq "sra"){p_b(6,0); p_r3(my $f2, my $f3, "r0"); p_b(5, my $f4); p_b(6,18);print("¥n");}
elsif ($op eq "lw"){p_b(6,16); p_r2i(my $f2, base($f3)); p_b(16, dpl(my $f3));print("¥n");}
elsif ($op eq "lh"){p_b(6,18); p_r2i(my $f2, base($f3)); p_b(16, dpl(my $f3));print("¥n");}
elsif ($op eq "lb"){p_b(6,20); p_r2i(my $f2, base($f3)); p_b(16, dpl(my $f3));print("¥n");}
elsif ($op eq "sw"){p_b(6,24); p_r2i(my $f2, base($f3)); p_b(16, dpl(my $f3));print("¥n");}
elsif ($op eq "sh"){p_b(6,26); p_r2i(my $f2, base($f3)); p_b(16, dpl(my $f3));print("¥n");}
elsif ($op eq "sb"){p_b(6,28); p_r2i(my $f2, base($f3)); p_b(16, dpl(my $f3));print("¥n");}
elsif ($op eq "beq") {p_b(6,32); p_r2b(my $f2, my $f3); p_b(16, $labels{$f4}-$i-1);print("¥n");}
elsif ($op eq "bne") {p_b(6,33); p_r2b(my $f2, my $f3); p_b(16, $labels{$f4}-$i-1);print("¥n");}
elsif ($op eq "blt") {p_b(6,34); p_r2b(my $f2, my $f3); p_b(16, $labels{$f4}-$i-1);print("¥n");}
elsif ($op eq "ble") {p_b(6,35); p_r2b(my $f2, my $f3); p_b(16, $labels{$f4}-$i-1);print("¥n");}
elsif ($op eq "j") {p_b(6,40); p_b(26, $labels{my $f2});print("¥n");}
elsif ($op eq "jal"){p_b(6, 41); p_b(26, $labels{my $f2});print("¥n");}
elsif ($op eq "jr"){p_b(6, 42); p_r3("r0", my $f2, "r0"); p_b(11, 0);print("¥n");}
else {print("ERROR: Illegal Instruction¥n");}
$i++;
}
close(FH);

#3
sub p_b{# $numを2進数$digitsに変換して出力
($digits, $num) = @_;
if ($num >= 0) {
printf("%0".$digits."b_", $num);
} else {
print(substr(sprintf(“%b ”, $num), 32-$digits)); # 64ビットOSのときは、32 -> 64
}
}

#4
sub p_r3{# R型のレジスタ番地を出力
($rd, $rs, $rt) = @_;
$rs =~ s/r//; p_b(5, $rs);
$rt =~ s/r//; p_b(5, $rt);
$rd =~ s/r//; p_b(5, $rd);
}

#5
sub p_r2i{# I型のレジスタ番地を出力
($rt, $rs) = @_;
$rs =~ s/r//; p_b(5, $rs);
$rt =~ s/r//; p_b(5, $rt);
}

#6
sub p_r2b{# 条件分岐で比較するレジスタ番地を出力
($rs, $rt) = @_;
$rs =~ s/r//; p_b(5, $rs);
$rt =~ s/r//; p_b(5, $rt);
}

#7
sub base{# ベースアドレスレジスタの番地を返す
($addr) = @_;
$addr =~ s/.*¥(//;
$addr =~ s/¥)//;
return($addr);
}

#8
sub dpl{# 変位を返す
($addr) = @_;
$addr =~ s/¥(.*¥)//;
return($addr);
}
