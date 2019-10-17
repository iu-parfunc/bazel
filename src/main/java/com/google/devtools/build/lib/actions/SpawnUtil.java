package com.google.devtools.build.lib.actions;

import com.google.common.collect.ImmutableList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class SpawnUtil {
  public static ImmutableList<String> augmentWithDettrace(List<String> arguments) {
    String dettrace = System.getenv("DETCMD");
    if (dettrace != null && ! dettrace.isEmpty() ) {
      // System.err.println("DET: Environment variable DETCMD set, using it: "+dettrace);
      LinkedList<String> dtArguments = new LinkedList<>(arguments);
      dtArguments.addFirst("--");
      dtArguments.addFirst(dettrace);
      return ImmutableList.copyOf(dtArguments);
    } else {
      // System.err.println("DET: Environment variable DETCMD unset, proceeding nondeterministically.");
      return ImmutableList.copyOf(arguments);
    }
  }
}

