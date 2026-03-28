# 定义多个引擎变量
$XeLaTex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$PDFLaTex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$LuaLaTex = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# 设置默认引擎
$pdflatex = $XeLaTex;

# ---------- 输出目录 ----------
$out_dir = ""; 
$aux_dir = ""; 

# ---------- 参考文献 ----------
add_cus_dep('aux', 'bbl', 0, 'run_bibtex_or_biber');

sub run_bibtex_or_biber {
    my $base = $_[0];
    my $cmd;
    if (-e "$base.bcf") {
        # 用 biber
        $cmd = "biber $base";
    } else {
        # 用 bibtex
        $cmd = "bibtex $base";
    }

    # 运行命令，屏蔽 stdout，保留 stderr
    # shell 重定向：stdout重定向到null设备，stderr保持输出
    # Windows和Linux的null设备不同，这里用Perl的判断
    my $null = ($^O eq 'MSWin32') ? "NUL" : "/dev/null";

    # 构造完整命令
    my $full_cmd = "$cmd 1>$null 2>&1";

    # 执行命令
    my $ret = system($full_cmd);

    # system返回值格式: 成功时为0，否则非0
    if ($ret != 0) {
        die "Error: command '$cmd' failed with exit code " . ($ret >> 8) . "\n";
    }
}