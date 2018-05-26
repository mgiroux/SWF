import PackageDescription
let package = Package(
	name: "SwiftWebFramework",
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        	.Package(url: "https://github.com/SwiftORM/MongoDB-StORM.git", majorVersion: 3),
        	.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 3),
        	.Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 3),
        	.Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0, minor: 11)
	]
)
