package com.google.devtools.build.lib.actions;

import com.google.common.collect.ImmutableList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class SpawnUtil {
  public static ImmutableList<String> augmentWithDettrace(List<String> arguments) {
    String dettrace = System.getenv("DETTRACE");
    if (dettrace != null) {
      LinkedList<String> dtArguments = new LinkedList<>(arguments);
      dtArguments.addFirst(dettrace);
      return ImmutableList.copyOf(dtArguments);
    } else {
      return ImmutableList.copyOf(arguments);
    }
  }
}
