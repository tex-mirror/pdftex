# the macros defined here are to help debugging pdftex
set history save on
set confirm off
set print elements 256

# print scaled
def ps
    print $0/65535.0
end

def pvf
    echo "w="
    p w
    echo "x="
    p x
    echo "y="
    p y
    echo "z="
    p z
end

# print the value of a string
def pstring
    print strpool[strstart[$arg0]]@strstart[$arg0+1]-strstart[$arg0]
end

# print font name as string
def pfontname
    pstring fontname[$arg0]
end

# print various values related to a font
def pfont
    echo "fontname = "
    pfontname $arg0
    echo "fontsize = "
    p fontsize[$arg0]/65536.0
    echo "pdffontautoexpand = "
    p pdffontautoexpand[$arg0]
end

# print type of node as string
def pnodetype
    if $arg0 >= himemmin
        echo char_node\n
    else
        if zmem[$arg0].hh.u.B0 == 0
            echo hlist_node\n
        end
        if zmem[$arg0].hh.u.B0 == 1
            echo vlist_node\n
        end
        if zmem[$arg0].hh.u.B0 == 2
            echo rule_node\n
        end
        if zmem[$arg0].hh.u.B0 == 3
            echo ins_node\n
        end
        if zmem[$arg0].hh.u.B0 == 4
            echo mark_node\n
        end
        if zmem[$arg0].hh.u.B0 == 5
            echo adjust_node\n
        end
        if zmem[$arg0].hh.u.B0 == 6
            echo ligature_node\n
        end
        if zmem[$arg0].hh.u.B0 == 7
            echo disc_node\n
        end
        if zmem[$arg0].hh.u.B0 == 8
            echo whatsit_node\n
        end
        if zmem[$arg0].hh.u.B0 == 9
            echo math_node\n
        end
        if zmem[$arg0].hh.u.B0 == 10
            echo glue_node\n
        end
        if zmem[$arg0].hh.u.B0 == 11
            echo kern_node\n
        end
        if zmem[$arg0].hh.u.B0 == 12
            echo penalty_node\n
        end
        if zmem[$arg0].hh.u.B0 == 13
            echo unset_node\n
        end
    end
end

# print type of a node
# def ptype
#     print mem[$arg0].hh.u.B0
# end
# 
# def psubtype
# print mem[$arg0].hh.u.B1
# end
# 
# def pfont
#     ptype $arg0
# end
# 
# def pchar
# psubtype($arg0)
# end
# 
# def pinfo
# print mem[$arg0].hh.v.LH
# end
# 
# def plink
# print mem[$arg0].hh.v.RH
# end
# 
# def pmarginchar
# pinfo($arg0+2)
# end
# 
# def setpdflatex
# set args -fmt=pdflatex $arg0
# end
