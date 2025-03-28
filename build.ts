import { type Build } from 'xbuild';

const build: Build = {
    common: {
        project: 'jsmn',
        archs: ['x64'],
        variables: [],
        copy: {
            'jsmn/jsmn.h': 'jsmn/jsmn.c'
        },
        defines: ['JSMN_IMPLEMENTATION'],
        options: [],
        subdirectories: [],
        libraries: {
            'jsmn': {
                sources: ['jsmn/jsmn.c']
            }
        },
        buildDir: 'build',
        buildOutDir: 'libs',
        buildFlags: []
    },
    platforms: {
        win32: {
            windows: {},
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {}
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;