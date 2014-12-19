module Config

// CONFIG CONSTANTS
public int LINES_TRESHOLD = 5;
public int MIN_SEQUENCE_LENGTH = 9; // For testing set this to 4
public int MAX_SEQUENCE_LENGTH = 10;// For testing set this to 15
public bool SUBSUMBTION_ALGO = true;
public bool SUBSUMBTION_SEQ_ALGO = true;
public bool OUTPUT_CLONE_CODE = true;
public bool OUTPUT_ALL_CLONES = false;
public bool OUTPUT_TO_FILES = false;
public loc REPORT_LOCATION = |home:///Repositories/SoftwareEvolution/reports/|;

// ALIAS TYPES
public alias Clone = set[loc];
public alias CloneClass = tuple[int, Clone];
public alias CloneMap[&T] = map[&T,set[loc]];

