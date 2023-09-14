// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import PythonSwiftCore
import PythonLib



private var pythonIsRunning = false

var pystdlib: URL {
    Bundle.module.url(forResource: "python_stdlib", withExtension: nil)!
}
public func initPython() {
    if pythonIsRunning { return }
    pythonIsRunning.toggle()
//    let resourcePath = "/Users/musicmaker/Library/Mobile Documents/com~apple~CloudDocs/Projects/xcode_projects/touchBay_files/touchBay/touchBay"
    let resourcePath: String
    if #available(macOS 13, *) {
        resourcePath = pystdlib.path()
    } else {
        resourcePath = pystdlib.path
    }
    print(resourcePath)
    var config: PyConfig = .init()
    print("Configuring isolated Python for Testing...")
    PyConfig_InitIsolatedConfig(&config)
    
    // Configure the Python interpreter:
    // Run at optimization level 1
    // (remove assertions, set __debug__ to False)
    config.optimization_level = 1
    // Don't buffer stdio. We want output to appears in the log immediately
    config.buffered_stdio = 0
    // Don't write bytecode; we can't modify the app bundle
    // after it has been signed.
    config.write_bytecode = 0
    // Isolated apps need to set the full PYTHONPATH manually.
    config.module_search_paths_set = 1
    
    var status: PyStatus
    
    let python_home = "\(resourcePath)"
    
    var wtmp_str = Py_DecodeLocale(python_home, nil)
    
    var config_home: UnsafeMutablePointer<wchar_t>!// = config.home
    
    status = PyConfig_SetString(&config, &config_home, wtmp_str)
    
    PyMem_RawFree(wtmp_str)
    
    config.home = config_home
    
    status = PyConfig_Read(&config)
    
    print("PYTHONPATH:")
    
    let path = "\(resourcePath)"
    //let path = "\(resourcePath)/"
    
    print("- \(path)")
    wtmp_str = Py_DecodeLocale(path, nil)
    status = PyWideStringList_Append(&config.module_search_paths, wtmp_str)
    
    PyMem_RawFree(wtmp_str)
    
    
    //PyImport_AppendInittab(makeCString(from: "fib"), PyInitFib)
    
    //PyErr_Print()
    
    //let new_obj = NewPyObject(name: "fib", cls: Int.self, _methods: FibMethods)
    print("Initializing Python runtime...")
    status = Py_InitializeFromConfig(&config)
        
}
