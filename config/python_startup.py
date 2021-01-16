import sys
 
class Quit_python(object):
    """
    Quit on q. (object)
 
    Overridden Methods:
    __repr__
    """
 
    def __repr__(self):
        """Quit on q. (None)"""
        sys.exit()
q = Quit_python()
