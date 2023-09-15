// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
//import PythonSwiftCore
import PythonLib



private var pythonIsRunning = false

var pystdlib: URL {
    Bundle.module.url(forResource: "python_stdlib", withExtension: nil)!
}
var pyextra: URL {
	Bundle.module.url(forResource: "python-extra", withExtension: nil)!
}
public func initPython() {
    if pythonIsRunning { return }
    pythonIsRunning.toggle()
//    let resourcePath = "/Users/musicmaker/Library/Mobile Documents/com~apple~CloudDocs/Projects/xcode_projects/touchBay_files/touchBay/touchBay"
    let resourcePath: String
	let python_extra: String
    if #available(macOS 13, *) {
        resourcePath = pystdlib.path()
    } else {
        resourcePath = pystdlib.path
    }
	if #available(macOS 13, *) {
		python_extra = pyextra.path()
	} else {
		python_extra = pyextra.path
	}
    print(resourcePath)
    var config: PyConfig = .init()
	var preconfig: PyPreConfig = .init()
    print("Configuring isolated Python for Testing...")
	
	PyPreConfig_InitIsolatedConfig(&preconfig)
    PyConfig_InitIsolatedConfig(&config)
    
	preconfig.utf8_mode = 1
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
	
	status = Py_PreInitialize(&preconfig)
    
    let python_home = "\(resourcePath)"
    
    var wtmp_str = Py_DecodeLocale(python_home, nil)
    
    var config_home: UnsafeMutablePointer<wchar_t>!// = config.home
    
//    status = PyConfig_SetString(&config, &config_home, wtmp_str)
//    
//    PyMem_RawFree(wtmp_str)
//    
//    config.home = config_home
    
    status = PyConfig_Read(&config)
    
    print("PYTHONPATH:")
    
    let path = "\(resourcePath)"
    //let path = "\(resourcePath)/"
    
    print("resourcePath - \(path)")
	print("\n")
    wtmp_str = Py_DecodeLocale(path, nil)
    status = PyWideStringList_Append(&config.module_search_paths, wtmp_str)
    
    PyMem_RawFree(wtmp_str)
	print(try! FileManager.default.contentsOfDirectory(atPath: path))
	let dynload_path = "\(resourcePath)lib-dynload"
	wtmp_str = dynload_path.withCString { Py_DecodeLocale($0, nil) }
	status = PyWideStringList_Append(&config.module_search_paths, wtmp_str)
	PyMem_RawFree(wtmp_str)
	print(dynload_path)
	
	wtmp_str = Py_DecodeLocale(python_extra, nil)
	//status = PyWideStringList_Append(&config.module_search_paths, wtmp_str)
	print(try! FileManager.default.contentsOfDirectory(atPath: dynload_path))
	PyMem_RawFree(wtmp_str)
    
    
    //PyImport_AppendInittab(makeCString(from: "fib"), PyInitFib)
    
    //PyErr_Print()
    
    //let new_obj = NewPyObject(name: "fib", cls: Int.self, _methods: FibMethods)
    print("Initializing Python runtime...")
    status = Py_InitializeFromConfig(&config)
        
}
