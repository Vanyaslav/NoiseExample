//
//  WhiteNoiseGenerator.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation
import CoreAudio

class KernelAudioUnit: AUAudioUnit {
    // MARK: Private
    private let kernel: AudioUnitSampleKernel = AudioUnitSampleKernel()
    
    private var outputBusArray: AUAudioUnitBusArray!
    private var internalRender: AUInternalRenderBlock!
    
    // MARK: Override init
    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions) throws {
        let kernel = self.kernel
        
        internalRender = { (actionFlags,
                            timeStamp,
                            frameCount,
                            outputBusNumber,
                            outputData,
                            renderEvent,
                            pullInputBlock) in
            
            guard let buffer = kernel.buffer else {
                return noErr
            }
            
            buffer.frameLength = frameCount
            
            if let renderBlock = kernel.renderBlock {
                renderBlock(buffer)
            }
            
            let out_abl = UnsafeMutableAudioBufferListPointer(outputData)
            let in_abl = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
            
            for i in 0 ..< out_abl.count {
                let out_data = out_abl[i].mData
                let in_data = in_abl[i].mData
                
                if out_data == nil {
                    out_abl[i].mData = in_data
                } else if out_data != in_data {
                    memcpy(out_data, in_data, Int(out_abl[i].mDataByteSize))
                }
            }
            
            return noErr
        }
        
        try super.init(componentDescription: componentDescription, options: options)
        guard let format = audioFormat() else {
            abort()
        }
        let bus = try AUAudioUnitBus(format: format)
        outputBusArray = AUAudioUnitBusArray(audioUnit: self,
                                             busType: AUAudioUnitBusType.output,
                                             busses: [bus])
    }
}
//
// MARK: Overrides
extension KernelAudioUnit {
    override var outputBusses : AUAudioUnitBusArray {
        outputBusArray
    }
    
    override var internalRenderBlock: AUInternalRenderBlock {
        internalRender
    }
    
    override func shouldChange(to format: AVAudioFormat,
                               for bus: AUAudioUnitBus) -> Bool {
        true
    }
    
    override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        //
        let bus = self.outputBusses[0]
        kernel.buffer = AVAudioPCMBuffer(pcmFormat: bus.format,
                                         frameCapacity: self.maximumFramesToRender)
    }
    
    override func deallocateRenderResources() {
        kernel.buffer = nil
    }
}

// MARK: Accessor
extension KernelAudioUnit {
    var kernelRenderBlock: KernelRenderBlock? {
        get { kernel.renderBlock }
        set { kernel.renderBlock = newValue }
    }
}
