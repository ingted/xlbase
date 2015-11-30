#!/usr/bin/pash

#$args.count;
$args | %{
        $arg = $_;
        [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($arg))
}
