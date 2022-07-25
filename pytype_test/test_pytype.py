import ast
import sys
from textwrap import indent
import textwrap
from pytype.tools.annotate_ast import annotate_ast
from pytype.tools.merge_pyi import merge_pyi
# import typed_ast.ast3 as tast
from pytype import analyze, errors, config, load_pytd
from pytype.pytd import pytd_utils

class Args:

  def __init__(self, as_comments=False):
    self.as_comments = as_comments

  @property
  def expected_ext(self):
    """Extension of expected filename."""
    exts = {
        0: 'pep484',
        1: 'comment',
    }
    return exts[int(self.as_comments)] + '.py'

def pytype_annotate_and_merge(src: str):
    typed_ast, _ = analyze.infer_types(src, errors.ErrorLog(), 
        config.Options.create(), load_pytd.Loader(config.Options.create()))
    pyi_src = pytd_utils.Print(typed_ast)
    args = Args(as_comments = 0)
    annotated_src = merge_pyi.annotate_string(args, src, pyi_src)
    return annotated_src

def test_annotate():
    code = '''def mult_int_and_string():
    a = 2
    return a * "test"'''
    source = textwrap.dedent(code.lstrip('\n'))
    pytype_options = config.Options.create(python_version=sys.version_info[:2])

    module = annotate_ast.annotate_source(source, ast, pytype_options)
    print(ast.unparse(module))


if __name__ == "__main__":
    code = '''def mult_int_and_string():
    a = 2
    return a * "test"'''
    res = pytype_annotate_and_merge(code)
    print(res)
    print("-------------")
    test_annotate()

