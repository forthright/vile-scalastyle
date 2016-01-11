module.exports = """
<?xml version="1.0" encoding="UTF-8"?>
<checkstyle version="5.0">
  <file name="#{process.cwd()}/test.scala">
    <error line="1" source="org.scalastyle.file.HeaderMatchesChecker" severity="warning" message="Header does not match expected text"/>
    <error column="36" line="3" source="org.scalastyle.file.RegexChecker" severity="warning" message="Regular expression matched 'println'"/>
    <error column="23" line="14" source="org.scalastyle.file.RegexChecker" severity="warning" message="Regular expression matched 'println'"/>
    <error column="6" line="2" source="org.scalastyle.scalariform.PublicMethodsHaveTypeChecker" severity="unknown" message="Public method must have explicit type"/>
  </file>
  <file name="#{process.cwd()}/some/folder/test_two.scala">
    <error source="org.scalastyle.file.SomeChecker" severity="error" message="Some message"/>
  </file>
</checkstyle>
"""
