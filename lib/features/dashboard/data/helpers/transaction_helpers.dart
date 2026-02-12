class TransactionHelpers {
  static String safeString(dynamic s, String key) {
    try {
      if (s is Map) return (s[key] ?? '').toString();
    } catch (_) {}
    try {
      final v = (s as dynamic);
      if (v != null) return v.toString();
    } catch (_) {}
    try {
      final v = (s as dynamic)[key];
      if (v != null) return v.toString();
    } catch (_) {}
    return '';
  }

  static num safeNum(dynamic s, String key) {
    try {
      if (s is Map) return (s[key] ?? 0) as num;
    } catch (_) {}
    try {
      final v = (s as dynamic).amount;
      if (v is num) return v;
      if (v != null) return num.parse(v.toString());
    } catch (_) {}
    return 0;
  }

  static DateTime safeDate(dynamic s) {
    try {
      if (s is Map) {
        final v = s['date'];
        if (v is DateTime) return v;
        if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
        if (v is String) return DateTime.parse(v);
      }
    } catch (_) {}
    try {
      final v = (s as dynamic).date;
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) return DateTime.parse(v);
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
