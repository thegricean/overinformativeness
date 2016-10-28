## Compositional semantics approach

- Look-up-table:
	- entry for each item ans color type
	- item entry:
		- how good are the different instances (color+item) for this category
		- e.g.,   
		"banana" : {  
        yellow\_banana : .9,  
        blue\_banana : .3,  
        yellow\_apple : .015,  
        blue\_apple : .015,  
        yellow\_cup : .015,  
        blue\_cup : .015  
        }
	- color entry:
		- how good is this specific color (as seen on the item) as an instance of this color  
		- e.g.,   
		"blue" : {  
        yellow\_banana : .015,  
        blue\_banana : .9,  
        yellow\_apple : .015,  
        blue\_apple : .9,  
        yellow\_cup : .015,  
        blue\_cup : .9  
        }

- Results we want:

|Inform. atyp. |Inform. typ.  |Overinf. atyp.|Overinf. typ. |Color comp. overinf. atyp.|Color comp. overinf. typ.|
|--------------|--------------|--------------|--------------|--------------|--------------|
|90-100%       |80%           |55%           |40%           |54%           |46%           |

- Results with alpha=13, cost\_color=1 and cost\_type=1:

Typicality Connector|Inform. atyp. |Inform. typ.  |Overinf. atyp.|Overinf. typ. |Color comp. overinf. atyp.|Color comp. overinf. typ.|
|-------------------|--------------|--------------|--------------|--------------|--------------|--------------|
|addition           |89%           |36%           |66%           |27%           |8%            |4%            |
|multiplication     |35%           |1%            |.6%           |.4%           |.6%           |.4%           |
|mean               |50%           |1%            |6%            |.6%           |1%            |.1%           |


- Results with alpha=13, cost\_color=.6 and cost\_type=.3:

Typicality Connector|Inform. atyp. |Inform. typ.  |Overinf. atyp.|Overinf. typ. |Color comp. overinf. atyp.|Color comp. overinf. typ.|
|-------------------|--------------|--------------|--------------|--------------|--------------|--------------|
|addition           |98%           |80%           |93%           |73%           |38%           |24%           |
|multiplication     |80%           |7%            |4%            |3%            |4%            |3%            |
|mean               |88%           |7%            |31%           |5%            |7%            |1%            |

- Results with alpha=5, cost\_color=1 and cost\_type=1:

Typicality Connector|Inform. atyp. |Inform. typ.  |Overinf. atyp.|Overinf. typ. |Color comp. overinf. atyp.|Color comp. overinf. typ.|
|-------------------|--------------|--------------|--------------|--------------|--------------|--------------|
|addition           |7%            |3%            |5%            |3%            |2%            |1%            |
|multiplication     |3%            |.7%           |.6%           |.5%           |.6%           |.5%           | 
|mean               |3%            |.7%           |1%            |.6%           |.7%           |.3%           |

- Results with alpha=20, cost\_color=1 and cost\_type=1:

Typicality Connector|Inform. atyp. |Inform. typ.  |Overinf. atyp.|Overinf. typ. |Color comp. overinf. atyp.|Color comp. overinf. typ.|
|-------------------|--------------|--------------|--------------|--------------|--------------|--------------|
|addition           |99%           |86%           |98%           |76%           |25%           |10%           |
|multiplication     |86%           |1%            |.5%           |.3%           |.5%           |.3%           | 
|mean               |94%           |1%            |17%           |.7%           |1%            |.06%          |
















